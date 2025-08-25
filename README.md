# pandoc-slack-markdown

A custom pandoc writer for Slack markdown (mrkdwn)

## Run

`pandoc -f md -t slack.lua example.md`

## Tests

Install [bats](https://bats-core.readthedocs.io/en/stable/index.html), bats-support, bats-assert

Run `bats tests`