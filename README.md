# hledger multiarch

Builds and publishes an [hledger](https://hledger.org) container image which works on amd64 and aarch64.

It contains the `hledger` binary and will also start up the [hledger-web](https://hledger.org/1.26/hledger-web.html) server

```bash
docker run \
    --name hledger \
    --env "HLEDGR_JOURNAL_FILE=/data/journal.ledger" \
    --env "LEDGER_FILE=/data/journal.ledger" \
    --env "HLEDGER_BASE_URL=http://localhost:5000" \
    -v /path/to/journal.ledger:/data/journal.ledger \
    -p 5000:5000 \
    ghcr.io/tgrosinger/hledger:1.26.1
```

Then open http://localhost:5000.
