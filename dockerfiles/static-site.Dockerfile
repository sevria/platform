FROM busybox:stable

# Create a non-root user to own the files and run our server
RUN adduser -D static
USER static
WORKDIR /home/static

# Copy the static website
COPY . .

# Run BusyBox httpd
CMD ["busybox", "httpd", "-f", "-p", "3000"]
