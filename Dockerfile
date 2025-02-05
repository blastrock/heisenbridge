FROM python:3.9 as build

WORKDIR /opt/heisenbridge
COPY . .
RUN python setup.py gen_version && \
    rm -rf .git

FROM python:3.9-slim

WORKDIR /opt/heisenbridge
COPY --from=build /opt/heisenbridge .

# install deps and run a sanity check
RUN pip install -e . && \
    python -m heisenbridge  -h

# identd also needs to be enabled with --identd in CMD
EXPOSE 9898/tcp 113/tcp
ENTRYPOINT ["heisenbridge", "-l", "0.0.0.0"]
CMD []
