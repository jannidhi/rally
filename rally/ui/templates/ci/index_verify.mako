## -*- coding: utf-8 -*-
<%inherit file="/base.mako"/>

<%block name="title_text">Rally Verification job results</%block>

<%block name="css">
    li { margin:2px 0 }
    a, a:visited { color:#039 }
    code { padding:0 15px; color:#888; display: block }
    .columns li { position:relative }
    .columns li > :first-child { display:block }
    .columns li > :nth-child(2) { display:block; position:static; left:165px; top:0; white-space:nowrap }
    .fail {color: red; text-transform: uppercase}
    .pass {color: green; display: none; text-transform: uppercase}
</%block>

<%block name="css_content_wrap">margin:0 auto; padding:0 5px</%block>

<%block name="media_queries">
    @media only screen and (min-width: 320px) { .content-wrap { width:400px } }
    @media only screen and (min-width: 520px) { .content-wrap { width:500px } }
    @media only screen and (min-width: 620px) { .content-wrap { width:90% } .columns li > :nth-child(2) { position:absolute } }
    @media only screen and (min-width: 720px) { .content-wrap { width:70% } }
</%block>

<%block name="header_text">Verify job results</%block>

<%block name="content">
    <h2>Job Logs and Job Result files</h2>
    <ul class="columns">
      <li><a href="console.html" class="rich">Job logs</a> <code>console.html</code>
      <li><a href="logs/">Logs of all services</a> <code>logs/</code>
      <li><a href="rally-verify/">Results files</a> <code>rally-verify/</code>
    </ul>

    <h2>Job Steps and Results</h2>
    <h3>Table</h3>
    <ul>
        <li>Tempest Management</li>
        <li>Launch two verifications</li>
        <li>Compare two verification results</li>
        <li>List all verifications</li>
    </ul>

    Each job step has output in all supported formats.

    <h4>Details</h4>
    <span class="${install['status']}">[${install['status']}]</span>
    <a href="${install['stdout_file']}">Tempest installation</a>
    <code>$ ${install['cmd']}</code>

    <span class="${genconfig['status']}">[${genconfig['status']}]</span>
    <a href="${genconfig['stdout_file']}">Tempest config generation</a>
    <code>$ ${genconfig['cmd']}</code>

    <span class="${showconfig['status']}">[${showconfig['status']}]</span>
    <a href="${showconfig['stdout_file']}">Tempest config</a>
    <code>$ ${showconfig['cmd']}</code>

    <br>First verification run
    <ol>
        <li>
            <span class="${first_run['status']}">[${first_run['status']}]</span>
            <a href="${first_run['stdout_file']}">Launch of verification</a>
            <code>$ ${first_run['cmd']}</code>
        </li>
        <li>
            <span class="${first_run['result_in_html']['status']}">[${first_run['result_in_html']['status']}]</span>
            <a href="${first_run['result_in_html']['output_file']}">Display raw results in HTML</a> [<a href="${first_run['result_in_html']['stdout_file']}">Output from CLI</a>]
            <code>$ ${first_run['result_in_html']['cmd']}</code>
        </li>
        <li>
            <span class="${first_run['result_in_json']['status']}">[${first_run['result_in_json']['status']}]</span>
            <a href="${first_run['result_in_json']['output_file']}">Display raw results in JSON</a> [<a href="${first_run['result_in_json']['stdout_file']}">Output from CLI</a>]
            <code>$ ${first_run['result_in_json']['cmd']}</code>
        </li>
        <li>
            <span class="${first_run['show']['status']}">[${first_run['show']['status']}]</span>
            <a href="${first_run['show']['stdout_file']}">Display results table of the verification</a>
            <code>$ ${first_run['show']['cmd']}</code>
        </li>
        <li>
            <span class="${first_run['show_detailed']['status']}">[${first_run['show_detailed']['status']}]</span>
            <a href="${first_run['show_detailed']['stdout_file']}">Display results table of the verification with detailed errors</a><br />
            <code>$ ${first_run['show_detailed']['cmd']}</code>
        </li>
    </ol>

    Second verification run
    <ol>
        <li>
            <span class="${second_run['status']}">[${second_run['status']}]</span>
            <a href="${second_run['stdout_file']}">Launch of verification</a>
            <code>$ ${second_run['cmd']}</code>
        </li>
        <li>
            <span class="${second_run['result_in_html']['status']}">[${second_run['result_in_html']['status']}]</span>
            <a href="${second_run['result_in_html']['output_file']}">Display raw results in HTML</a> [<a href="${second_run['result_in_html']['stdout_file']}">Output from CLI</a>]
            <code>$ ${second_run['result_in_html']['cmd']}</code>
        </li>
        <li>
            <span class="${second_run['result_in_json']['status']}">[${second_run['result_in_json']['status']}]</span>
            <a href="${second_run['result_in_json']['output_file']}">Display raw results in JSON</a> [<a href="${second_run['result_in_json']['stdout_file']}">Output from CLI</a>]
            <code>$ ${second_run['result_in_json']['cmd']}</code>
        </li>
        <li>
            <span class="${second_run['show']['status']}">[${second_run['show']['status']}]</span>
            <a href="${second_run['show']['stdout_file']}">Display results table of the verification</a>
            <code>$ ${second_run['show']['cmd']}</code>
        </li>
        <li>
            <span class="${second_run['show_detailed']['status']}">[${second_run['show_detailed']['status']}]</span>
            <a href="${second_run['show_detailed']['stdout_file']}">Display results table of the verification with detailed errors</a><br />
            <code>$ ${second_run['show_detailed']['cmd']}</code>
        </li>
    </ol>

    <span class="${compare['html']['status']}">[${compare['html']['status']}]</span>
    <a href="${compare['html']['output_file']}">Compare two verifications and display results in HTML</a> [<a href="${compare['html']['stdout_file']}">Output from CLI</a>]
    <code>$ rally verify compare --uuid-1 &lt;uuid-1&gt; --uuid-2 &lt;uuid-2&gt; --html</code>

    <span class="${compare['json']['status']}">[${compare['json']['status']}]</span>
    <a href="${compare['json']['output_file']}">Compare two verifications and display results in JSON</a> [<a href="${compare['json']['stdout_file']}">Output from CLI</a>]
    <code>$ rally verify compare --uuid-1 &lt;uuid-1&gt; --uuid-2 &lt;uuid-2&gt; --json</code>

    <span class="${compare['csv']['status']}">[${compare['csv']['status']}]</span>
    <a href="${compare['csv']['output_file']}">Compare two verifications and display results in CSV</a> [<a href="${compare['csv']['stdout_file']}">Output from CLI</a>]
    <code>$ rally verify compare --uuid-1 &lt;uuid-1&gt; --uuid-2 &lt;uuid-2&gt; --csv</code>

    <span class="${list['status']}">[${list['status']}]</span>
    <a href="${list['stdout_file']}">List of all verifications</a>
    <code>$ ${list['cmd']}</code>

    <h2>About Rally</h2>
    <p>Rally is benchmarking and verification system for OpenStack:</p>
    <ul>
      <li><a href="https://github.com/openstack/rally">Git repository</a>
      <li><a href="https://rally.readthedocs.org/en/latest/">Documentation</a>
      <li><a href="https://wiki.openstack.org/wiki/Rally/HowTo">How to use Rally (locally)</a>
      <li><a href="https://wiki.openstack.org/wiki/Rally/RallyGates">How to add Rally job to your project</a>
      <li><a href="https://www.mirantis.com/blog/rally-openstack-tempest-testing-made-simpler/">Rally: OpenStack Tempest Testing Made Simple(r) [a little outdated blog-post, but contains basic of Rally verification]</a>
    </ul>
</%block>
