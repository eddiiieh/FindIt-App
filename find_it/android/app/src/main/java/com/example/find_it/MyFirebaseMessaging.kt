// FirebaseMessagingService.kt
package com.example.find_it

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import androidx.core.app.NotificationCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class MyFirebaseMessagingService : FirebaseMessagingService() {

    override fun onNewToken(token: String) {
        // Send token to your server
        print("FCM Token: $token")
    }

    override fun onMessageReceived(message: RemoteMessage) {
        // 1. Extract payload data
        val itemId = message.data["item_id"] ?: ""
        val title = message.notification?.title ?: "New Item"
        val body = message.notification?.body ?: ""

        // 2. Save to SharedPreferences (for Flutter to read) - REMOVED
        // val prefs = getSharedPreferences("notifications", MODE_PRIVATE)
        // prefs.edit().apply {
        //     putString("last_notification", "$title|$body|$itemId")
        //     apply()
        // }

        // 3. Show system notification
        sendNotification(title, body, itemId)
    }

    private fun sendNotification(title: String, body: String, itemId: String) {
        val channelId = "high_importance_channel"
        val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "FindIt Notifications",
                NotificationManager.IMPORTANCE_HIGH
            ).apply { description = "New found items" }
            notificationManager.createNotificationChannel(channel)
        }

        val notification = NotificationCompat.Builder(this, channelId)
            .setContentTitle(title)
            .setContentText(body)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setAutoCancel(true)
            .build()

        notificationManager.notify(itemId.hashCode(), notification) // Unique ID
    }
}