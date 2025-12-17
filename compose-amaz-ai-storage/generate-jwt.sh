#!/bin/bash

# Script to generate JWT tokens for Supabase
# This script generates ANON_KEY and SERVICE_KEY tokens

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Error: .env file not found!"
    exit 1
fi

# Get JWT_SECRET from .env file
JWT_SECRET=$(grep "^JWT_SECRET=" .env | cut -d'=' -f2)

if [ -z "$JWT_SECRET" ]; then
    echo "Error: JWT_SECRET not found in .env file!"
    exit 1
fi

echo "Generating JWT tokens with secret: $JWT_SECRET"

# Generate tokens using Python
python3 << EOF
import jwt
from datetime import datetime, timedelta
import sys

secret = "$JWT_SECRET"

# Generate anon key
anon_payload = {
    "iss": "supabase",
    "role": "anon",
    "exp": int((datetime.now() + timedelta(days=365*10)).timestamp())
}
anon_token = jwt.encode(anon_payload, secret, algorithm="HS256")

# Generate service_role key
service_payload = {
    "iss": "supabase",
    "role": "service_role",
    "exp": int((datetime.now() + timedelta(days=365*10)).timestamp())
}
service_token = jwt.encode(service_payload, secret, algorithm="HS256")

print(f"ANON_KEY={anon_token}")
print(f"SERVICE_KEY={service_token}")
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ JWT tokens generated successfully!"
    echo ""
    echo "📝 Copy the tokens above and update your .env file:"
    echo "   - Replace the ANON_KEY line"
    echo "   - Replace the SERVICE_KEY line"
    echo ""
    echo "Or run this command to update automatically:"
    echo "   ./generate-jwt.sh | grep -E '^(ANON|SERVICE)_KEY=' > .env.jwt && cat .env.jwt"
else
    echo "❌ Error generating tokens. Make sure PyJWT is installed:"
    echo "   pip install PyJWT"
    exit 1
fi
