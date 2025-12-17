import jwt
import json
from datetime import datetime, timedelta

# Your JWT secret from docker-compose.yml
secret = "super-secret-jwt-super-secret-jwt"

# Generate anon key
anon_payload = {
    "iss": "supabase",
    "role": "anon",
    "exp": int((datetime.now() + timedelta(days=365*10)).timestamp())  # 10 years
}

anon_token = jwt.encode(anon_payload, secret, algorithm="HS256")

# Generate service_role key
service_payload = {
    "iss": "supabase",
    "role": "service_role",
    "exp": int((datetime.now() + timedelta(days=365*10)).timestamp())  # 10 years
}

service_token = jwt.encode(service_payload, secret, algorithm="HS256")

print("ANON_KEY:")
print(anon_token)
print("\nSERVICE_KEY:")
print(service_token)
