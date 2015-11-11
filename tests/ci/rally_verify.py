#!/usr/bin/env python
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

import argparse
import gzip
import logging
import os
import subprocess
import sys

from rally.cli import envutils
from rally.ui import utils

LOG = logging.getLogger(__name__)
LOG.addHandler(logging.StreamHandler())
LOG.setLevel(logging.DEBUG)


MODES_PARAMETERS = {
    "full": "--set full",
    "light": "--set compute"
}

BASE_DIR = "rally-verify"

# NOTE(andreykurilin): this variable is used to generate output file names
# with prefix ${CALL_COUNT}_ .
_call_count = 0
# NOTE(andreykurilin): if some command fails, script should end with
# error status
_return_status = 0


def call_rally(cmd, print_output=False, output_type=None):
    global _return_status
    global _call_count
    _call_count += 1

    data = {"cmd": "rally --rally-debug %s " % cmd,
            "stdout_file": "%(base)s/%(prefix)s_%(cmd)s.txt.gz" % {
                "base": BASE_DIR, "prefix": _call_count,
                "cmd": cmd.replace(" ", "_")}}

    if output_type:
        data["output_file"] = data["stdout_file"].replace(
            ".txt.", ".%s." % output_type)
        data["cmd"] += " --%(type)s --output-file %(file)s" % {
            "type": output_type, "file": data["output_file"]}

    try:
        LOG.info("Try to launch `%s`." % data["cmd"])
        stdout = subprocess.check_output(data["cmd"], shell=True,
                                         stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        LOG.error("Command `%s` is failed." % data["cmd"])
        stdout = e.output
        data["status"] = "fail"
        _return_status = 1
    else:
        data["status"] = "pass"

    if output_type:
        # lets gzip results
        with open(data["output_file"]) as f:
            output = f.read()
        with gzip.open(data["output_file"], "wb") as f:
            f.write(output)

    stdout = "$ %s\n%s" % (data["cmd"], stdout)

    with gzip.open(data["stdout_file"], "wb") as f:
        f.write(stdout)

    if print_output:
        print(stdout)

    return data


def launch_verification_once(launch_parameters):
    """Launch verification and show results in different formats."""
    results = call_rally("verify start %s" % launch_parameters)
    results["uuid"] = envutils.get_global(envutils.ENV_VERIFICATION)
    results["result_in_html"] = call_rally(
        "verify results --html", output_type="html")
    results["result_in_json"] = call_rally(
        "verify results --json", output_type="json")
    results["show"] = call_rally("verify show")
    results["show_detailed"] = call_rally("verify show --detailed")
    # NOTE(andreykurilin): we need to clean verification uuid from global
    # environment to be able to load it next time(for another verification).
    envutils.clear_global(envutils.ENV_VERIFICATION)
    return results


def do_compare(uuid_1, uuid_2):
    """Compare and save results in different formats."""
    results = {}
    for output_format in ("csv", "html", "json"):
        cmd = ("verify compare --uuid-1 %(uuid-1)s --uuid-2 %(uuid-2)s "
               "--%(output_format)s") % {
            "uuid-1": uuid_1,
            "uuid-2": uuid_2,
            "output_format": output_format
        }
        results[output_format] = call_rally(cmd, output_type=output_format)
    return results


def render_page(**render_vars):
    # TODO(andreykurilin): port template to jinja2
    template = utils.get_template("ci/index_verify.mako")
    with open(os.path.join(BASE_DIR, "extra/index.html"), "w") as f:
        f.write(template.render(**render_vars))


def main():
    parser = argparse.ArgumentParser(description="Launch rally-verify job.")
    parser.add_argument(
        "--mode",
        type=str,
        default="light",
        help="mode of job",
        choices=MODES_PARAMETERS.keys())
    parser.add_argument(
        "--compare",
        action="store_true",
        help="Launch 2 verification and compare them.")
    args = parser.parse_args()

    if not os.path.exists("%s/extra" % BASE_DIR):
        os.makedirs("%s/extra" % BASE_DIR)

    # Check deployment
    call_rally("deployment use --deployment devstack", print_output=True)
    call_rally("deployment check", print_output=True)

    render_vars = {}

    # Verification management stuff
    render_vars["install"] = call_rally("verify install")
    render_vars["genconfig"] = call_rally("verify genconfig")
    render_vars["showconfig"] = call_rally("verify showconfig")

    # Launch verification
    render_vars["first_run"] = launch_verification_once(
        MODES_PARAMETERS[args.mode])

    if args.compare:
        render_vars["second_run"] = launch_verification_once(
            MODES_PARAMETERS[args.mode])
        render_vars["compare"] = do_compare(
            render_vars["first_run"]["uuid"],
            render_vars["second_run"]["uuid"])
    else:
        raise NotImplementedError("You are unable to disable compare now.")

    render_vars["list"] = call_rally("verify list")

    render_page(**render_vars)

    return _return_status

if __name__ == "__main__":
    sys.exit(main())
