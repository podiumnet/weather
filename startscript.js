#!/usr/bin/env node
require("child_process").spawn(
  "./node_modules/electron-prebuilt/dist/electron",
  ["."],
  {detached: true});
process.exit();
