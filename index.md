---
layout: default
title: Lectures
---

{% for lecture in site.lectures %}
  <a href="{{ lecture.url | relative_url }}">{{lecture.title}}</a>
{% endfor %}
