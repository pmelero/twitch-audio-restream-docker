# Twitch Audio Restream Docker

This repository contains a Docker image designed to stream audio from a Twitch channel and broadcast it using Icecast. With this setup, you can easily restream Twitch audios.
Based on [docker-icecast](https://github.com/moul/docker-icecast) and [twitch-audio-restreamer](https://github.com/meyerlasse/twitch-audio-restreamer) with some improvements.

## Features
- Streams audio from a specified list of Twitch channels.
- Configured with Icecast for audio broadcasting.
- Optinal save audio files in MP3 format.
- Supports environment variable customization for flexibility.

## Configuration

### Environment Variables

Before running the container, configure the following environment variables:

| Variable                  | Description                                                  |
|---------------------------|--------------------------------------------------------------|
| `TWITCH_USERNAMES`        | List of Twitch usernames to monitor, separated by spaces.    |
| `ICECAST_PASSWORD`        | Password for the Icecast source.                            |
| `ICECAST_RELAY_PASSWORD`  | Password for the Icecast relay.                             |
| `ICECAST_ADMIN_PASSWORD`  | Password for the Icecast admin.                             |
| `SAVE_TO_FILE`            | Boolean variable (`true` or `false`) to save streams as files. |

---

## Usage

### 1. Clone the Repository

Clone this repository to your local machine or server:

```bash
git clone https://github.com/pmelero/twitch-audio-restream-docker.git
cd twitch-audio-restream-docker
```

### 2. Build and Run the Docker Container

```bash
docker build -t twitch-audio-restream .
```

Run the container with the configured environment variables:

```bash
docker run -d --name twitch-audio-restream \
    -e TWITCH_USERNAMES="user1 user2" \
    -e ICECAST_SOURCE_PASSWORD=hackme \
    -e ICECAST_RELAY_PASSWORD=hackme \
    -e ICECAST_ADMIN_PASSWORD=hackme \
    -e ICECAST_PASSWORD=hackme \
    -e SAVE_TO_FILE=true \
    -v /path/to/local/folder:/app/audio \
    -p 8000:8000 \
    twitch-audio-restream
```

Single line command:

```sh
docker run -d --name twitch-audio-restream -e TWITCH_USERNAMES="user1 user2" -e ICECAST_SOURCE_PASSWORD=hackme -e ICECAST_RELAY_PASSWORD=hackme -e ICECAST_ADMIN_PASSWORD=hackme -e ICECAST_PASSWORD=hackme -e SAVE_TO_FILE=true -v /path/to/local/folder:/app/audio -p 8000:8000 twitch-audio-restream
```

Replace `/path/to/local/folder` with the path on your host machine

### 3. Verify the Container

Check if the container is running correctly:

```bash
docker logs twitch-audio-restream
```

### Accessing the Stream

Once the container is running, the stream will be accessible at:

```
http://<your-server-ip>:8000
```

Replace `<your-server-ip>` with the IP address of the host running the container.

You can see each active audio stream in icecast web. You will be able to listen each at:

```
http://<your-server-ip>:8000/[user]
```

## Customization

You can modify the `Dockerfile` or `start.sh` to adjust dependencies or add additional features. Ensure to rebuild the image after making changes:



## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

Feel free to contribute, report issues, or fork this repository to fit your needs!

