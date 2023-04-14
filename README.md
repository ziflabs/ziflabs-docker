# Zero-IF Labs Docker Images

Dockerfiles for GNU Radio 3.10 and other SDR-related things on Ubuntu 22.04.

## Docker Installation

1. installation: https://docs.docker.com/engine/install/ubuntu/
2. post-installation tasks: https://docs.docker.com/engine/install/linux-postinstall/

## NVIDIA Drivers Installation

These steps are only necessary for using [gr-fosphor](https://gitea.osmocom.org/sdr/gr-fosphor), a GPU-based real-time spectrum analyzer block for GNU Radio.

* https://docs.nvidia.com/datacenter/tesla/tesla-installation-notes/index.html#ubuntu-lts

Note that even on Ubuntu 22.04, the resulting repository URL will redirect to download NVIDIA packages targeted for Ubuntu 18.04. Also take note of the NVIDIA driver version installed, as you may need to modify the `gnuradio310` Dockerfile with the appropriate version.

Then set up the NVIDIA container runtime repository by following the steps here:

* https://nvidia.github.io/nvidia-container-runtime/#debian-based-distributions

Finally, install the runtime and NVIDIA Docker wrapper utility:

```bash
$ sudo apt update
$ sudo apt install nvidia-container-runtime nvidia-docker2
```

**REBOOT HOST COMPUTER BEFORE NEXT STEP!**

## Building Images

Each directory has build scripts (either `clean_build.sh` or the incremental `build.sh`). Build images in the following order:

Order | Image(s) | Description
----- | -------- | -----------
1st | `sdrs` | NVIDIA GPU drivers, [UHD](https://github.com/EttusResearch/uhd), and [Signal Hound SDK](https://signalhound.com/software/signal-hound-software-development-kit-sdk/)
2nd | `gnuradio310` | [VOLK](https://github.com/gnuradio/volk), [GNU Radio](https://github.com/gnuradio/gnuradio) 3.10, and several OOT modules
3rd | `xxx` | project-specific images (in other repositories)

The base image (`sdrs`) will also set up a non-root user with `sudo` access whose name is derived from the host user - this is all handled automatically through the build scripts. Be sure to run the `udev.sh` script to install udev rules on the host (which will allow non-sudo access of SDR hardware inside the container).

For the GNU Radio image, you may need to swap out the NVIDIA driver version in order to match the version on your host. Find the NVIDIA driver version with the following command:

```
$ apt list --installed | grep nvidia-driver
nvidia-driver-530/unknown,now 530.30.02-0ubuntu1 amd64 [installed,automatic]
```

If the driver version is not equal to `530`, change `nvidia-driver-XXX` in the following line of the Dockerfile:

```
    cmake xorg-dev libglu1-mesa-dev nvidia-driver-530 nvidia-opencl-dev opencl-headers clinfo nvidia-modprobe
```

## Running

Allow docker containers to connect to the host X11 server. It's best to just add this to the host `~/.bashrc` file.
```
xhost +local:docker
```

The [gnuradio310/)](gnuradio310/) directory contains example run scripts that show how to start a container based on these images. Once inside the container, open GNU Radio Companion:

```bash
dev@2b310945025e:~$ gnuradio-companion
```

And the GUI should come up:

![GNU Radio Companion running inside Docker container](screenshot.png)
