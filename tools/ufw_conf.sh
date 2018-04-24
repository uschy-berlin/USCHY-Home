#!/bin/bash
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 22/tcp
ufw logging medium
ufw default deny incoming
ufw enable
