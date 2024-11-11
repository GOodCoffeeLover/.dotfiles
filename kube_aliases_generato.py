#!/usr/bin/env python
# -*- coding: utf-8 -*-

# ORIGINAL: https://github.com/ahmetb/kubectl-aliases/blob/master/generate_aliases.py 

# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from __future__ import print_function
import itertools
import sys


def main():
    # (alias, full, allow_when_oneof, incompatible_with)
    cmds = [('k', 'kubectl', None, None)]

    globs = [
            #('sys', '--namespace=kube-system', None, None),
            ]

    res = [
        ('p', 'pod', ['c', 'g', 'd', 'del'], None),
        ('d', 'deployment', ['c', 'g', 'd', 'del'], None),
        ('ss', 'statefulset', ['c', 'g', 'd', 'del'], None),
        ('s', 'service', ['c', 'g', 'd', 'del'], None),
        ('i', 'ingress', ['c', 'g', 'd', 'del'], None),
        ('cm', 'configmap', ['c', 'g', 'd', 'del'], None),
        ('sc', 'secret', ['c', 'g', 'd', 'del'], None),
        ('no', 'node', ['c', 'g', 'd'], None),
        ('ns', 'namespace', ['c', 'g', 'd', 'del'], None),
        # ('a', 'all', ['c', 'g', 'd'], None),
        ('cl', 'cluster', ['c', 'g', 'd', 'del'], None),
        ('acl', 'avotocluster', ['c', 'g', 'd', 'del'], None),
        ('md', 'machinedeployment', ['c', 'g', 'd', 'del'], None),
        ('mp', 'machinepool', ['c', 'g', 'd', 'del'], None),
        ('m', 'machine', ['c', 'g', 'd', 'del'], None),
        ('pm', 'platformmachine', ['c', 'g', 'd', 'del'], None),
    ]
    res_types = [r[0] for r in res]


    ops = [
        ('a', 'apply', None, res_types),
        ('as', 'apply --server-side', None, res_types),
        ('eti', 'exec -t -i', None, None),
        ('l', 'logs', None, None),
        ('lf', 'logs -f', None, None),
        ('lfp', 'logs -f -p', None, None),
        ('p', 'proxy', None, None),
        ('pf', 'port-forward', None, None),
        ('g', 'get', None, None),
        ('d', 'describe', None, None),
        ('del', 'delete', None, None),
        ('c', 'create', None, ['a']),
        ('rit', 'run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t', None, None),
        ]

    args = [
        ('oy', '-o=yaml', ['g'], ['ow', 'oj', 'sl']),
        ('ow', '-o=wide', ['g'], ['oy', 'oj']),
        ('oj', '-o=json', ['g'], ['ow', 'oy', 'sl']),
        ('A', '--all-namespaces', ['g', 'd'], ['del', 'f', 'no']),
        ('sl', '--show-labels', ['g'], ['oy', 'oj'], None),
        ('a', '--all', ['del'], None), # caution: reusing the alias
        ('w', '--watch', ['g'], ['oy', 'oj', 'ow']),
        ]

    # these accept a value, so they need to be at the end and
    # mutually exclusive within each other.
    positional_args = [
            ('f', '--recursive -f', ['g', 'd', 'del', 'a', 'as'], res_types), 
            ('l', '-l', ['g', 'd', 'del'], ['f', 'all']),
            ('n', '--namespace', ['g', 'd', 'del', 'l', 'eti', 'pf'], ['ns', 'no']),
            ]

    # [(part, optional, take_exactly_one)]
    parts = [
        (cmds, False, True),
        # (globs, True, False),
        (ops, True, True),
        (res, True, True),
        (args, True, False),
        (positional_args, True, True),
        ]

    shellFormatting = {
        "bash": "alias -g {}='{}'",
        "zsh": "alias -g {}='{}'",
        "fish": "abbr --add {} \"{}\"",
    }

    shell = sys.argv[1] if len(sys.argv) > 1 else "bash"
    if shell not in shellFormatting:
        raise ValueError("Shell \"{}\" not supported. Options are {}"
                        .format(shell, [key for key in shellFormatting]))

    out = gen(parts)

    seen_aliases = {}

    for cmd in out:
        alias = ''.join([a[0] for a in cmd])
        command = ' '.join([a[1] for a in cmd])
        if "kubectl deployment" in command:
            print("skip deployment use as command".format(alias, command, seen_aliases[alias]), file=sys.stderr)
            continue

        if alias in seen_aliases.keys():
            print("Alias conflict detected on {} for commands: {} and {}".format(alias, command, seen_aliases[alias]), file=sys.stderr)

        seen_aliases[alias] = command

        print(shellFormatting[shell].format(alias, command))


def gen(parts):
    out = [()]
    for (items, optional, take_exactly_one) in parts:
        orig = list(out)
        combos = []

        if optional and take_exactly_one:
            combos = combos.append([])

        if take_exactly_one:
            combos = combinations(items, 1, include_0=optional)
        else:
            combos = combinations(items, len(items), include_0=optional)

        # permutate the combinations if optional (args are not positional)
        if optional:
            new_combos = []
            for c in combos:
                new_combos += list(itertools.permutations(c))
            combos = new_combos

        new_out = []
        for segment in combos:
            for stuff in orig:
                if is_valid(stuff + segment):
                    new_out.append(stuff + segment)
        out = new_out
    return out


def is_valid(cmd):
    return is_valid_requirements(cmd) and is_valid_incompatibilities(cmd)


def is_valid_requirements(cmd):
    parts = {c[0] for c in cmd}

    for i in range(0, len(cmd)):
        # check at least one of requirements are in the cmd
        requirements = cmd[i][2]
        if requirements and len(parts & set(requirements)) == 0:
            return False

    return True


def is_valid_incompatibilities(cmd):
    parts = {c[0] for c in cmd}

    for i in range(0, len(cmd)):
        # check none of the incompatibilities are in the cmd
        incompatibilities = cmd[i][3]
        if incompatibilities and len(parts & set(incompatibilities)) > 0:
            return False

    return True


def combinations(a, n, include_0=True):
    l = []
    for j in range(0, n + 1):
        if not include_0 and j == 0:
            continue

        cs = itertools.combinations(a, j)

        # check incompatibilities early
        cs = (c for c in cs if is_valid_incompatibilities(c))

        l += list(cs)

    return l


def diff(a, b):
    return list(set(a) - set(b))


if __name__ == '__main__':
    main()
