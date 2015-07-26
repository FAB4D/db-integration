import io
import sys
import ConfigParser
import string

_core_options = ['server', 'name', 'user', 'password']

def load_config(db_dir, config_section):
    cp = ConfigParser.ConfigParser()
    config_fn = db_dir + "/db_config.ini"
    print config_fn
    cp.read(config_fn)
    _config = dict()
    if config_section in cp.sections():
        for opt in cp.options(config_section):
            _config[opt] = string.strip(cp.get(config_section, opt))

    tables = dict() 
    for key in _config:
        if key not in _core_options:
            tables[key] = _config[key]

    return [_config, tables]

