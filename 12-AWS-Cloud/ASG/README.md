# Auto Scaling Group

Use this folder for Auto Scaling Group launch templates, user data, fleet setup notes, and scaling test scripts.

## User data example

```bash
#!/bin/bash
set -e

PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4 || echo "unknown")
echo "Hello this is EC2 instance and public IP: ${PUBLIC_IP}" > /var/www/html/index.html
```

This writes a simple message with the instance public IP to the web page.

Make sure the instance security group allows inbound TCP 80, or the browser will show `ERR_CONNECTION_REFUSED`.

## CPU load test script

Run `autoscaling-example.sh` on one EC2 instance to generate CPU load and trigger an Auto Scaling policy.

Example:

```bash
chmod +x autoscaling-example.sh
./autoscaling-example.sh 80 300
```

This targets about 80% CPU for 300 seconds.
