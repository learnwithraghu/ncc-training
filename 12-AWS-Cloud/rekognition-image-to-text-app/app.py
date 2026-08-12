import os

import boto3
from botocore.exceptions import BotoCoreError, ClientError
from flask import Flask, render_template_string, request

app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 5 * 1024 * 1024

rekognition = boto3.client("rekognition")

PAGE = """
<!doctype html>
<html>
  <head>
    <title>Image to Text</title>
    <style>
      body { font-family: sans-serif; max-width: 650px; margin: 50px auto; padding: 20px; }
      button { margin-top: 12px; padding: 8px 16px; }
      pre { background: #f4f4f4; padding: 15px; white-space: pre-wrap; }
      .error { color: #b00020; }
    </style>
  </head>
  <body>
    <h1>Image to Text</h1>
    <p>Upload a JPEG or PNG image containing text.</p>
    <form method="post" enctype="multipart/form-data">
      <input type="file" name="image" accept=".jpg,.jpeg,.png" required>
      <br>
      <button type="submit">Extract text</button>
    </form>
    {% if error %}<p class="error">{{ error }}</p>{% endif %}
    {% if text %}<h2>Detected text</h2><pre>{{ text }}</pre>{% endif %}
  </body>
</html>
"""


@app.route("/", methods=["GET", "POST"])
def index():
    text = ""
    error = ""

    if request.method == "POST":
        image = request.files.get("image")

        if not image or not image.filename.lower().endswith((".jpg", ".jpeg", ".png")):
            error = "Please upload a JPEG or PNG image."
        else:
            try:
                response = rekognition.detect_text(Image={"Bytes": image.read()})
                lines = [
                    item["DetectedText"]
                    for item in response["TextDetections"]
                    if item["Type"] == "LINE"
                ]
                text = "\n".join(lines) or "No text was detected."
            except (BotoCoreError, ClientError) as exc:
                error = f"AWS Rekognition error: {exc}"

    return render_template_string(PAGE, text=text, error=error)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "5000")))
