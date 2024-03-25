FROM osrf/ros:noetic-desktop-full

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y git \
 && rm -rf /var/lib/apt/lists/*

# apt packages
RUN apt-get update \
 && apt-get install -y libgoogle-glog-dev libgflags-dev \
      libatlas-base-dev libeigen3-dev libsuitesparse-dev \
      ros-noetic-pcl-conversions \
 && rm -rf /var/lib/apt/lists/*

# Source code dependencies
RUN git clone https://ceres-solver.googlesource.com/ceres-solver \
 && cd ceres-solver && mkdir build && cd build \
 && cmake .. && make install && cd .. && rm -fr ceres-solver

# PPA and apt packages
RUN apt-get update \
 && apt-get install -y software-properties-common \
 && rm -rf /var/lib/apt/lists/*
 
RUN add-apt-repository ppa:borglab/gtsam-release-4.0 \
 && apt-get update \
 && apt-get install -y libgtsam-dev libgtsam-unstable-dev \
 && rm -rf /var/lib/apt/lists/*

# Code repository

RUN mkdir -p /catkin_ws/src/

RUN git clone --recurse-submodules \
      https://github.com/RobotResearchRepos/hku-mars_STD \
      /catkin_ws/src/STD

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /catkin_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.sh \
 && cd /catkin_ws \
 && catkin_make
 
 
