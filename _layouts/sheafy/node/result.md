<section>
  {% unless page.topmost -%}
    <span id="{{ page.slug }}">
      <a class="slug" href="{{ page.url | relative_url }}">[{{ page.slug }}]</a>
      <strong>
        {{ page.genus | default: 'Theorem' }}
        <span class="numbering">{{ page.clicks | to_numbering }}</span>
      </strong>
      {% if page.title != page.slug %}({{ page.title }}).{% endif -%}
    </span>
  {%- endunless %}
  {{ content }}
</section>
