# Use the official Alpine image
FROM alpine:latest

# Install curl and bash
RUN apk add --no-cache curl bash

# Set the working directory
WORKDIR /app

# Copy the spam_votes.sh script
COPY spam_votes.sh .

# Make the script executable
RUN chmod +x spam_votes.sh

# Start the script
CMD ["./spam_votes.sh"]

