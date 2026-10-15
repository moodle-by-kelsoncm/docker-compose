<?php
function env($name, $default=null) {
  return getenv($name, true) ?: $default;
}
function env_as_int($name, $default=null) {
  return intval(env($name, $default));
}
function env_as_bool($name, $default=null) {
  return in_array(strtoupper(env($name, $default)), ['Y', 'YES', 'T', 'TRUE', '1']);
}

if (isset($CFG) && is_object($CFG)) {
  $CFG->routerconfigured = env_as_bool('CFG_ROUTERCONFIGURED', true);
}
