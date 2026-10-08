"""Render Chromium managed-policy JSON for one browser profile and tier.

Reads Brave-Omega/Browsers/<browser>.json and Brave-Omega/Profiles/*.json
(one directory above Scripts/) and prints the managed-policy object:
{"PolicyName": value, ...}. Only stdlib is used so the same file runs on
the Linux target inside Install-OmegaLinux.sh and in CI checks.
"""
import argparse
import io
import json
import os
import sys

TIERS = ['BraveOnly', 'Essential', 'Balanced', 'Advanced', 'Strict']


def repo_root():
    return os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def load_json(path):
    with io.open(path, encoding='utf-8-sig') as fh:
        return json.load(fh)


def render(root, browser, tier, platform):
    profile = load_json(os.path.join(root, 'Brave-Omega', 'Browsers', browser + '.json'))
    origins = set(profile['origins'])
    merged = {}
    for name in TIERS[:TIERS.index(tier) + 1]:
        data = load_json(os.path.join(root, 'Brave-Omega', 'Profiles', name + '.json'))
        for policy in data['policies']:
            origin = policy.get('origin', 'chromium')
            if origin not in origins:
                continue
            platforms = policy.get('platforms', ['windows'])
            if platform not in platforms:
                continue
            values = policy.get('platformValues', {})
            if platform in values:
                value = values[platform]
            else:
                value = policy['value']
            if isinstance(value, str):
                # Windows stores structured values as REG_SZ text; managed
                # JSON wants the structure itself.
                try:
                    parsed = json.loads(value)
                except ValueError:
                    parsed = None
                if isinstance(parsed, (dict, list)):
                    value = parsed
            merged[policy['name']] = value
    return merged


def main(argv):
    parser = argparse.ArgumentParser(description='Render managed policy JSON.')
    parser.add_argument('--browser', required=True, help='brave | chrome')
    parser.add_argument('--tier', required=True, choices=TIERS)
    parser.add_argument('--platform', default='linux', choices=['windows', 'linux'])
    parser.add_argument('--root', default=repo_root())
    args = parser.parse_args(argv)
    try:
        merged = render(args.root, args.browser, args.tier, args.platform)
    except (IOError, OSError, ValueError, KeyError) as exc:
        sys.stderr.write('error: %s\n' % exc)
        return 2
    sys.stdout.write(json.dumps(merged, indent=2, sort_keys=True) + '\n')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
