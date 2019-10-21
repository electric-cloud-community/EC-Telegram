How to use it?
================
## Receiving the Token 
At first, go to a @BotFather and create your bot. Here you will get your API token.

## Know your auditory
### Sending message to a personal chat
It's pretty hard to get your personal chat_id unless you know the following:
 * Find your bot in the Telegram search.
 * Press the 'Start' button.
 * Call [https://api.telegram.org/bot[yourTokenHere]/getUpdates]()
 * Find a {message}->{chat}->{id} value in the JSON.
 * Ensure this is a message from you.
 * Use this value as a receiver.
 * Profit!
 
### Sending message to a channel
This one should be easier:
 * Create a channel (if you're not already owning one).
 * Open Channel settings and get the channel link. It should be something like 'https://t.me/your_channel_id'
 * Use the part after t.me/ with an '@' prepended as a receiver (**@your_channel_id** in this case).
 * Profit!