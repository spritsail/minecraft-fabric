def main(ctx):
  return [
    step("1.20.6", "0.16.3"),
    step("1.21.1", "0.16.3", ["latest"]),
  ]

def step(mcver,fabricver,tags=[],jre="21"):
  return {
    "kind": "pipeline",
    "name": "build-%s" % mcver,
    "environment": {
      "DOCKER_IMAGE_TOKEN": "%s-%s" % (mcver, fabricver),
    },
    "steps": [
      {
        "name": "build",
        "image": "spritsail/docker-build",
        "pull": "always",
        "settings": {
          "build_args": [
            "MC_VER=%s" % mcver,
            "JRE_VER=%s" % jre,
            "FABRIC_VER=%s" % fabricver,
          ],
        },
      },
      {
        "name": "test",
        "image": "spritsail/docker-test",
        "pull": "always",
        "settings": {
          "exec_pre": "echo eula=true > eula.txt",
          "log_pipe": "grep -qm 1 \\'Done ([0-9]\\\\+\\\\.[0-9]\\\\+s)\\\\!\\'",
          "timeout": 600,
        },
      },
      {
        "name": "publish",
        "image": "spritsail/docker-publish",
        "pull": "always",
        "settings": {
          "repo": "spritsail/minecraft-fabric",
          "tags": [
            mcver,
            "%s-%s" % (mcver, fabricver),
          ] + tags,
          "login": {
            "from_secret": "docker_login",
          },
        },
        "when": {
          "branch": ["master"],
          "event": ["push"],
        },
      },
    ]
  }

