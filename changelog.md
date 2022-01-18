---
layout: page
title: Changelog
---

<style>

  details > summary {
    margin-left: 30px;
    margin-bottom: 15px;
    padding-inline-start: 1ch;
  }

  details[open] > summary {
    display: none;
  }

  summary { list-style: none; }
  summary::-webkit-details-marker { display: none; }

  details summary::before { 
    position: absolute;
    transform: translateX(-100%);
    padding-right: 1ch;
    content: '⧆';
    color: hsl(0, 0%, 40%);
  }

  summary {
    cursor: pointer; 
    margin-left: 30px;
    padding-inline-start: 1ch;
  }

  li.diff-A, li.diff-M, li.diff-D {
    padding-inline-start: 1ch;
  }
  li.diff-A { list-style-type: '⊞'; }
  li.diff-M { list-style-type: '⊡'; } /* ⧇ */
  li.diff-D { list-style-type: '⊟'; }
  li.diff-A::marker { color: hsl(120, 100%, 40%); }
  li.diff-M::marker { color: hsl(240, 100%, 40%); }
  li.diff-D::marker { color: hsl(  0, 100%, 40%); }

</style>

<dl>

{% for commit in page.commits %}

<dt>

<strong>{{ commit.timestamp | date_to_string }}</strong>

<a href="https://github.com/jonsterling/math/commit/{{ commit.hash }}">
<code>{{ commit.hash | truncate: 7, "" }}</code>
</a>

{{ commit.subject }}

</dt>

<dd>

{% capture commit_list %}

<ul>
  {% for diff in commit.diffs %}
  <li class="diff-{{ diff.status }}">

    {% if diff.node %}
    <a href="{{diff.node.url | relative_url}}">
      {{diff.node.title}}
      {% if diff.node.collection == "nodes" %}
      <span class="slug">[{{diff.node.slug}}]</span>
      {% endif %}
    </a>
    {% else %}
    <del>{{ diff.path | split: "/" | last | remove: ".md" }}</del>
    {% endif%}

  </li>
  {% endfor %}
</ul>
{% endcapture %}

<details {% if commit.diffs.size < 7 %}open{% endif %}>
<summary markdown='span'>Click to (un)fold the list of all {{ commit.diffs.size }} affected nodes.</summary>
{{ commit_list }}
</details>
</dd>

{% endfor %}

</dl>
