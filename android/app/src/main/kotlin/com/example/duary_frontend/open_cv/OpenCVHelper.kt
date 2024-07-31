package com.example.duary_frontend.open_cv

import org.opencv.core.CvType
import org.opencv.core.Mat
import org.opencv.core.MatOfPoint
import org.opencv.core.Point
import org.opencv.core.Scalar
import org.opencv.core.Size
import org.opencv.imgproc.Imgproc

data class Circle(val centerX: Double, val centerY: Double, val radius: Double)
data class Rectangle(val centerX: Double, val centerY: Double, val width: Double, val height: Double)
data class Polygon(val points: List<Pair<Double, Double>>)

class OpenCVHelper {
    companion object {
        init {
            System.loadLibrary("opencv_java4")
        }
        fun detectShapesFromPoints(points: List<Pair<Float, Float>>, width: Double, height: Double): List<Any> {
            // 빈 이미지 생성
            val mat = Mat.zeros(Size(width, height), CvType.CV_8UC3)

            // Points를 MatOfPoint로 변환
            val matOfPoint = MatOfPoint()
            val pointArray = points.map { Point(it.first.toDouble(), it.second.toDouble()) }.toTypedArray()
            matOfPoint.fromArray(*pointArray)

            // 윤곽선 그리기
            val contours = ArrayList<MatOfPoint>()
            contours.add(matOfPoint)
            Imgproc.drawContours(mat, contours, -1, Scalar(0.0, 255.0, 0.0), 2)

            val shapes = mutableListOf<Any>()

            // 도형 검출
            val grayMat = Mat()
            Imgproc.cvtColor(mat, grayMat, Imgproc.COLOR_BGR2GRAY)
            Imgproc.GaussianBlur(grayMat, grayMat, Size(5.0, 5.0), 0.0)

            // 원 검출
            val circles = Mat()
            Imgproc.HoughCircles(
                grayMat,
                circles,
                Imgproc.HOUGH_GRADIENT,
                1.0,
                grayMat.rows() / 8.0,
                100.0,
                30.0,
                0,
                0
            )

            for (i in 0 until circles.cols()) {
                val circleVec = circles[0, i]
                val center = Point(circleVec[0], circleVec[1])
                val radius = circleVec[2]
                shapes.add(Circle(center.x, center.y, radius))
            }

            val rect = Imgproc.boundingRect(matOfPoint)
            shapes.add(Rectangle(rect.x + rect.width / 2.0, rect.y + rect.height / 2.0, rect.width.toDouble(), rect.height.toDouble()))

//            val polygon = contours.first().toArray().map { Pair(it.x, it.y) }
//            shapes.add(Polygon(polygon))

            return shapes
        }

    }
}