#!/bin/bash

installed() {
  local program=$1
  hash $program 2>|/dev/null
}
