+++
author = ""
date = "2016-08-14T15:52:52+10:00"
description = "Securing CentOS, SSH, setup Nginx"
tags = ["Tech"]
title = "How to Host Static Websites Like Hugo on CentOS VPS with Nginx - Tutorial Part 2"
+++
![](/blogFiles/photo-1457365050282-c53d772ef8b2.jpg)
# Summary
Last time we:

- Spun VPS machine on Vultr
- Connected domain name to that VPS

Now we will learn how to:

- Secure our CentOS installation
- Setup SSH for passwordless login
- Setup NginX

# Secure CentOS
CentOS is quite secure out of the box, but we can do a little bit more to enhance it.

First we have to log in to the server using ssh

```bash
ssh root@[ip]
# in my case, it would be ssh root@45.32.190.53
```

When asked to trust the fingerprint, just type `yes`. You can get the password to the instance from the Vultr control panel.
