#!/bin/bash

set -e

sudo chown -R rails:rails .

exec "$@"