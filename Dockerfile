# Use the same base image as your RunPod template
FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

# Set environment variables to prevent interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install essential build tools + git
RUN apt-get update && apt-get install -y \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspace

# Copy your installation script into the image
COPY flux_install.sh /workspace/flux_install.sh

# Make the script executable and run it.
RUN chmod +x /workspace/flux_install.sh && \
    /workspace/flux_install.sh

# Set the working directory for the final CMD
WORKDIR /workspace/ComfyUI

# Expose the port ComfyUI will listen on
EXPOSE 8188

# Command to start ComfyUI when the container launches
CMD ["python", "main.py", "--listen", "--port", "8188", "--preview-method", "auto"]