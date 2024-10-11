#!/bin/bash

# Arrays containing possible values for synthetic data
product_categories=("Electronics" "Clothing" "Home" "Books" "Sports")
payment_methods=("Credit Card" "PayPal" "Bank Transfer" "Cash")

# Path to the customer profile file
customer_profile_file="./src/main/data/customer_profiles.json"

# Function to pick a random customer profile from the profile file
get_random_customer() {
  total_customers=$(jq length "$customer_profile_file")
  random_index=$((RANDOM % total_customers))
  customer=$(jq .[$random_index] "$customer_profile_file")
  echo "$customer"
}

# Function to generate a random transaction using an existing customer profile
generate_synthetic_transaction() {
  # Get a random customer profile
  customer=$(get_random_customer)
  customer_id=$(echo "$customer" | jq -r '.customer_id')

  # Randomly pick values for product category and payment method
  product_category=${product_categories[$RANDOM % ${#product_categories[@]}]}
  payment_method=${payment_methods[$RANDOM % ${#payment_methods[@]}]}
  
  # Generate a random transaction amount between 10 and 1000
  transaction_amount=$(awk -v min=10 -v max=1000 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')
  
  # Get the current timestamp in UTC format
  timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  # Create a JSON object for the transaction
  transaction=$(cat <<EOF
{
  "transaction_id": "$(cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 32 | head -n 1)",
  "customer_id": "$customer_id",
  "product_category": "$product_category",
  "payment_method": "$payment_method",
  "transaction_amount": $transaction_amount,
  "timestamp": "$timestamp"
}
EOF
)

  # Output both the transaction and customer profile
  echo "Transaction:"
  echo "$transaction"
  echo "Customer Profile:"
  echo "$customer"
}

# Infinite loop to continuously generate synthetic data
while true; do
  # Generate a transaction and output it
  generate_synthetic_transaction
  
  # Sleep for a short interval to simulate continuous data generation
  sleep 1
done
