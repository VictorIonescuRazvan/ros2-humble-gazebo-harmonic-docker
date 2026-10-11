# https://hub.docker.com/r/osrf/ros
# https://github.com/osrf/docker_images/blob/master/ros/humble/ubuntu/jammy/desktop-full/Dockerfile
FROM osrf/ros:humble-desktop

ARG user_id=1000
ARG ros_ws=/home/dockeruser/dev_ws

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl lsb-release gnupg ca-certificates \
    # setup repo
    && curl -fsSL https://packages.osrfoundation.org/gazebo.gpg \
        -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" \
        > /etc/apt/sources.list.d/gazebo-stable.list \
    # install
    && apt-get update && apt-get install -y --no-install-recommends \
        gz-harmonic \
        ros-${ROS_DISTRO}-ros-gzharmonic \
        python-is-python3 \
        nano \
        less \
        xterm \
    # graphical dry-run env
    && apt-get install -y --no-install-recommends \
        xvfb xauth libgl1-mesa-dri \
    # cleanup
    && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN mkdir -p /run/user/1000 \
    && chown 1000:1000 /run/user/1000 \
    && chmod 700 /run/user/1000
ENV XDG_RUNTIME_DIR=/run/user/1000

RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && LIBGL_ALWAYS_SOFTWARE=1 xvfb-run -a \
       timeout 180 gz sim -r --iterations 10 empty.sdf \
    && ls -l ~/.gz/sim/8/

# Switch to a non-root user.
RUN useradd -m --uid ${user_id} dockeruser
USER dockeruser


# Working directory
WORKDIR /home/dockeruser

# ENVs
ENV HOME=/home/dockeruser
ENV PATH="/home/dockeruser/.local/bin:${PATH}"

# Force Python stdout and stderr streams to be unbuffered.
ENV PYTHONUNBUFFERED 1

RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
RUN echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc \
    && echo "export _colcon_cd_root=${ros_ws}" >> ~/.bashrc

# ogre2 to ogre patch in gz config
RUN mkdir -p ~/.gz/sim/8
RUN if [ -f ~/.gz/sim/8/gui.config ]; then \
         sed -i 's/ogre2/ogre/g' ~/.gz/sim/8/gui.config; \
       else \
         echo "Skipping gui.config patch: file not found" >&2; \
       fi

# ogre2 to ogre patcher for post build
COPY --chown=dockeruser:dockeruser post_build.sh /home/dockeruser/.local/bin/post_build.sh
RUN chmod +x /home/dockeruser/.local/bin/post_build.sh

# .bashrc
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc \
    && echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc \
    && echo "export _colcon_cd_root=${ros_ws}" >> ~/.bashrc \
    && echo "alias colcon='post_build.sh && colcon'" >> ~/.bashrc

COPY --chown=dockeruser:dockeruser server.config.sample /home/dockeruser/.gz/sim/8/server.config

# This entrypoint is from base image.
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["sleep", "infinity"]