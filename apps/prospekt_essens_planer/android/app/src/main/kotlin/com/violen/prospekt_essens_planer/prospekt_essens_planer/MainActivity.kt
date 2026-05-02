package com.violen.prospekt_essens_planer.prospekt_essens_planer

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import com.tom_roush.pdfbox.pdmodel.PDDocument
import com.tom_roush.pdfbox.text.PDFTextStripper
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.violen.prospekt_essens_planer/pdf_extractor"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize PDFBox
        PDFBoxResourceLoader.init(applicationContext)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "extractText") {
                val filePath = call.argument<String>("filePath")
                if (filePath != null) {
                    try {
                        val text = extractTextFromPdf(filePath)
                        result.success(text)
                    } catch (e: Exception) {
                        result.error("PDF_ERROR", "Failed to extract text: ${e.message}", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "FilePath is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun extractTextFromPdf(filePath: String): String {
        val file = File(filePath)
        val document = PDDocument.load(file)
        val stripper = PDFTextStripper()
        val text = stripper.getText(document)
        document.close()
        return text
    }
}
