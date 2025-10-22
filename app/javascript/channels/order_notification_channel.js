import consumer from "./consumer"

const userId = document.body.dataset.userId

consumer.subscriptions.create(
  { channel: "OrderNotificationChannel", user_id: userId },
  {
    received(data) {
      // 1️⃣ Show popup alert
      alert(data.message)

      // 2️⃣ Optional: increment bell counter
      const bellCounter = document.getElementById("notification-count")
      if (bellCounter) {
        bellCounter.textContent = parseInt(bellCounter.textContent || 0) + 1
      }
    }
  }
)
