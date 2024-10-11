#!/bin/bash

# Expanded arrays for customer data
first_names=("John" "Jane" "Alice" "Bob" "Charlie" "Diana" "Eve" "Frank" "Grace" "Hank" "Ivy" "Jack" "Karen" "Leo" "Mona" "Nina" "Oscar" "Paul" "Quinn" "Rachel" "Sam" "Tina" "Uma" "Victor" "Wendy" "Xander" "Yara" "Zane")
last_names=("Smith" "Doe" "Johnson" "Brown" "Williams" "Jones" "Garcia" "Martinez" "Davis" "Rodriguez" "Miller" "Wilson" "Moore" "Taylor" "Anderson" "Thomas" "Hernandez" "Jackson" "White" "Harris" "Martin" "Thompson" "Lee" "Perez" "Young" "Sanchez" "Clark" "Ramirez" "Lewis" "Robinson")
email_domains=("example.com" "mail.com" "business.com" "company.org" "domain.net" "corporate.co" "webmail.com" "service.org" "site.com" "client.com")
customer_regions=("North America" "Europe" "Asia" "South America" "Africa" "Oceania" "Middle East" "Central America" "Eastern Europe" "Northern Europe" "Southern Europe" "Western Europe" "East Asia" "Southeast Asia" "South Asia" "North Africa" "Sub-Saharan Africa" "Australia" "New Zealand")

# Number of customer profiles to generate
num_customers=1000

# File to store customer profiles
customer_profile_file="./src/main/data/customer_profiles.json"

# Function to generate customer profiles with unique customer_id
generate_customer_profiles() {
  echo "[" > "$customer_profile_file"

  for ((i=1; i<=num_customers; i++)); do
    # Generate a unique customer_id (using a numerical sequence)
    customer_id="CUST$(printf "%05d" $i)"  # Example: CUST00001, CUST00002, etc.
    
    # Randomly pick first name, last name, and generate email
    first_name=${first_names[$RANDOM % ${#first_names[@]}]}
    last_name=${last_names[$RANDOM % ${#last_names[@]}]}
    email="${first_name}.${last_name}@${email_domains[$RANDOM % ${#email_domains[@]}]}"
    
    # Generate random age and region
    age=$((RANDOM % 60 + 18))  # Age between 18 and 77
    customer_region=${customer_regions[$RANDOM % ${#customer_regions[@]}]}

    # Create a JSON object for the customer profile
    profile=$(cat <<EOF
{
  "customer_id": "$customer_id",
  "first_name": "$first_name",
  "last_name": "$last_name",
  "email": "$email",
  "age": $age,
  "customer_region": "$customer_region"
}
EOF
)

    echo "$profile" >> "$customer_profile_file"

    # Add a comma except after the last profile
    if [ "$i" -lt "$num_customers" ]; then
      echo "," >> "$customer_profile_file"
    fi
  done

  echo "]" >> "$customer_profile_file"
}

# Generate the customer profiles
generate_customer_profiles
