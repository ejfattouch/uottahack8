#!/bin/bash

# Build script for MeshFlow-Markets and its dependencies
# This ensures the base image is always rebuilt before the main application

set -e  # Exit on any error

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}Building MeshFlow-Markets Docker Images${NC}"
echo -e "${BLUE}======================================${NC}\n"

# Step 1: Build the base image from solace-agent-meshwise
echo -e "${YELLOW}[1/2] Building base image (my-sam-base:latest)...${NC}"
echo -e "${YELLOW}      Location: solace-agent-meshwise/${NC}"
echo -e "${YELLOW}      Building without cache to ensure WebUI changes are included${NC}\n"

cd solace-agent-meshwise

if docker build --no-cache -t my-sam-base:latest .; then
    echo -e "\n${GREEN}✓ Base image built successfully${NC}\n"
else
    echo -e "\n${RED}✗ Failed to build base image${NC}"
    exit 1
fi

# Step 2: Build MeshFlow-Markets (using fresh base image with your local changes)
echo -e "${YELLOW}[2/2] Building MeshFlow-Markets image...${NC}"
echo -e "${YELLOW}      Location: MeshFlow-Markets/${NC}"
echo -e "${YELLOW}      Note: Using local solace-agent-mesh from base image (not PyPI)${NC}\n"

cd ../MeshFlow-Markets

if docker build -t meshflow-markets:latest .; then
    echo -e "\n${GREEN}✓ MeshFlow-Markets image built successfully${NC}\n"
else
    echo -e "\n${RED}✗ Failed to build MeshFlow-Markets image${NC}"
    exit 1
fi

# Success message with run instructions
echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Build Complete!${NC}"
echo -e "${GREEN}======================================${NC}\n"

echo -e "${BLUE}To run the application:${NC}"
echo -e "  docker run --name sam-app -p 8000:8000 -p 5002:5002 meshflow-markets:latest\n"

echo -e "${BLUE}To run with environment variables from .env file:${NC}"
echo -e "  docker run --name sam-app --env-file MeshFlow-Markets/.env -p 8000:8000 -p 5002:5002 meshflow-markets:latest\n"

echo -e "${BLUE}Images created:${NC}"
docker images | grep -E "(my-sam-base|meshflow-markets)" | head -2
