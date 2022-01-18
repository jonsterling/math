---
layout: page
title: Changelog
---

<style>
details[open] > summary:first-of-type {
  display: none;
}
details > summary:first-of-type {
  margin-left: 12px;
  margin-bottom: 15px;
}
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
{% include list.html list=commit.nodes %}
{% endcapture %}

{% if commit.nodes.size > 5 %}

<details>
<summary markdown='span'>Click to show all {{ commit.nodes.size }} affected nodes.</summary>
{{ commit_list }}
</details>

{% else %}
{{ commit_list }}
{% endif %}

</dd>

{% endfor %}

</dl>
