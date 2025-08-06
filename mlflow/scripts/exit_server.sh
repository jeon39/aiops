#!/bin/bash

ps ux | grep mlflow | awk '{print $2}' | xargs 'kill'
