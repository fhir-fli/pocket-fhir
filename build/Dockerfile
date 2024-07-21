# Use a multi-stage build to compile PocketBase and set up Caddy
FROM golang:1.22.4-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy the Go module files
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY src/ ./

# Build the PocketBase server
RUN CGO_ENABLED=0 go build -o /app/pocketfhir

# Use a lightweight image for the final container
FROM caddy:2.6.2-alpine

# Create a non-root user
RUN addgroup -S caddy && adduser -S caddy -G caddy

# Set the working directory
WORKDIR /app

# Copy the PocketBase executable from the builder stage
COPY --from=builder /app/pocketfhir /app/

# Copy Caddy configuration file
COPY config/caddy/Caddyfile.prod /etc/caddy/Caddyfile

# Ensure pb_data, pb_public, and pb_hooks directories exist
RUN mkdir -p /cloud/storage/pb_data /cloud/storage/pb_public /cloud/storage/pb_hooks

# Copy entrypoint script
COPY build/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Change ownership of /app and /cloud/storage directories to the non-root user
RUN chown -R caddy:caddy /app /cloud/storage

# Expose the necessary port for Cloud Run
EXPOSE 8080

# Switch to the non-root user
USER caddy

# Command to run the entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
