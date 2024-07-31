package com.example.duary_frontend

import com.example.duary_frontend.open_cv.Circle
import com.example.duary_frontend.open_cv.OpenCVHelper
import com.example.duary_frontend.open_cv.Polygon
import com.example.duary_frontend.open_cv.Rectangle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.Executors

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.duary_frontend/opencv"
    private val executorService = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "detectShapeFromPoints") {
                val arguments = call.arguments as Map<String, Any>
                val pointsJson = arguments["points"] as String
                val width = arguments["width"] as Double
                val height = arguments["height"] as Double

                val points = parsePoints(pointsJson)
                executorService.submit {
                    val shapes = OpenCVHelper.detectShapesFromPoints(points, width, height)
                    val jsonArray = JSONArray()
                    for (shape in shapes) {
                        when (shape) {
                            is Circle -> {
                                val jsonObject = JSONObject()
                                jsonObject.put("type", "circle")
                                jsonObject.put("center_x", shape.centerX)
                                jsonObject.put("center_y", shape.centerY)
                                jsonObject.put("radius", shape.radius)
                                jsonArray.put(jsonObject)
                            }
                            is Rectangle -> {
                                val jsonObject = JSONObject()
                                jsonObject.put("type", "rectangle")
                                jsonObject.put("center_x", shape.centerX)
                                jsonObject.put("center_y", shape.centerY)
                                jsonObject.put("width", shape.width)
                                jsonObject.put("height", shape.height)
                                jsonArray.put(jsonObject)
                            }
                            is Polygon -> {
                                val jsonObject = JSONObject()
                                jsonObject.put("type", "polygon")
                                val pointsArray = JSONArray()
                                for (point in shape.points) {
                                    val pointObject = JSONObject()
                                    pointObject.put("x", point.first)
                                    pointObject.put("y", point.second)
                                    pointsArray.put(pointObject)
                                }
                                jsonObject.put("points", pointsArray)
                                jsonArray.put(jsonObject)
                            }
                        }
                    }

                    runOnUiThread {
                        result.success(jsonArray.toString())
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun parsePoints(pointsJson: String): List<Pair<Float, Float>> {
        val pointsArray = JSONArray(pointsJson)
        val points = mutableListOf<Pair<Float, Float>>()
        for (i in 0 until pointsArray.length()) {
            val point = pointsArray.getJSONArray(i)
            points.add(Pair(point.getDouble(0).toFloat(), point.getDouble(1).toFloat()))
        }
        return points
    }
}
