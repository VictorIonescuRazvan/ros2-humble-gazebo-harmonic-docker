# ROS2 Humble with Gazebo Harmonic, dockerised

## What is this?

* A Docker container for ROS2 Humble and Gazebo Harmonic.
* GUI is enabled if WSLg is installed.

## Prerequisites

* docker, docker-compose
* (Optional) WSLg

## Installation (WSL / Linux)
### 1. Prerequisites (always)
```bash
sudo apt update && sudo apt install docker docker-compose
git clone https://github.com/VictorIonescuRazvan/ros2-humble-gazebo-harmonic-docker.git
cd ros2-humble-gazebo-harmonic-docker
```
### 2. (Option 1) Build the image locally
This will take a few good minutes.
```bash
docker compose build
```

### (Option 2) Resolve submodules
This can also take some time depending on your network connection
```bash
git submodule update --init --recursive
docker load -i "ros2-humble-gazebo-harmonic-built-container/ros2-humble-gazebo-harmonic-docker-ros2.tar.gz"
```

### 3. Run
```bash
docker compose up -d
docker compose exec ros2 bash
```

### 4. Connect later
```bash
docker compose exec ros2 bash
```

## Test
```bash
ros2 run turtlesim turtlesim_node
```