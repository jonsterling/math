class InPageSearch {
  constructor() {
    this.NODE_TAG = "SECTION"; // MUST be uppercase to be both selector and nodeName
    this.FOLDED_CLASS = "ellipsis";
    this.MARKJS_EXCLUDE_FOLDED = ".ellipsis *";
    this.INPUT_NAME = "q";
    this.URL_PARAM = "q";
    this.DOC_REF_KEY = "slug";
    this.DOC_VAL_KEY = "text";

    this.form = document.getElementById("search-form");
    this.fieldset = this.form.querySelector("fieldset");
    this.input = document.getElementById("search-query");
    this.toggle = document.getElementById("search-toggle");
    this.bindEvents();

    this.nodeDocuments = [];
    this.nodeElements = {};
    this.nodeVisibilities = {};
    this.initialized = false;

    this.checkURL();
  }

  //=[ Initialization ]=========================================================

  async lazyInit() {
    if (this.initialized) return;
    this.initBookkeeping();
    this.initIndex(this.nodeDocuments);
    this.initialized = true;
  }

  initBookkeeping() {
    document.querySelectorAll(this.NODE_TAG).forEach((element) => {
      this.nodeElements[element.id] = element;
      this.nodeVisibilities[element.id] = true;
      this.nodeDocuments.push({
        [this.DOC_REF_KEY]: element.id,
        [this.DOC_VAL_KEY]: this.extractSearchableText(element),
      });
    });
  }

  extractSearchableText(element) {
    return [...element.children]
      .filter((e) => e.nodeName != this.NODE_TAG)
      .map((e) => e.innerText)
      .join("\n");
  }

  //=[ URI ]====================================================================

  checkURL() {
    const q = this.getURLQuery();
    if (q) {
      this.handleToggle();
      this.input.value = q;
      this.run(q);
    }
  }

  getURLQuery() {
    var url = new URL(window.location.href);
    return url.searchParams.get(this.URL_PARAM);
  }

  setURLQuery(q) {
    if (!history.replaceState) return;
    var url = new URL(window.location.href);
    url.searchParams.set(this.URL_PARAM, q);
    window.history.replaceState(null, null, url);
  }

  deleteURLQuery() {
    if (!history.replaceState) return;
    var url = new URL(window.location.href);
    url.searchParams.delete(this.URL_PARAM);
    window.history.replaceState(null, null, url);
  }

  //=[ Operation ]==============================================================

  async run(q) {
    this.lazyInit();

    await this.setFormLock(true);

    const results = this.searchIndex(q);

    this.setVisibilities(false);
    this.setVisibilitiesFromResults(results);
    this.applyVisibilities();

    await this.promiseToUnmarkTree();
    await this.promiseToMarkTree(results);

    await this.setFormLock(false);

    this.setURLQuery(q);
  }

  async clear() {
    await this.setFormLock(true);

    await this.promiseToUnmarkTree();

    this.setVisibilities(true);
    this.applyVisibilities();

    await this.setFormLock(false);

    this.deleteURLQuery();
  }

  //=[ Indexing ]===============================================================

  initIndex(documents) {
    const that = this; // sigh.
    this.index = lunr(function () {
      this.ref(that.DOC_REF_KEY);
      this.field(that.DOC_VAL_KEY);
      documents.forEach(this.add.bind(this));
    });
  }

  searchIndex(query) {
    return this.index.search(query);
  }

  //=[ (Un)folding ]============================================================

  setVisibilities(status) {
    Object.keys(this.nodeVisibilities).forEach(
      this.setVisibility.bind(this, status)
    );
  }

  setVisibility(status, slug) {
    this.nodeVisibilities[slug] = status;
  }

  showSectionAndAncestors(nodeEl) {
    if (nodeEl.nodeName != this.NODE_TAG) return;
    if (this.nodeVisibilities[nodeEl.id]) return;
    this.nodeVisibilities[nodeEl.id] = true;
    this.showSectionAndAncestors(nodeEl.parentNode);
  }

  setVisibilitiesFromResults(results) {
    results.map(({ ref }) =>
      this.showSectionAndAncestors(this.nodeElements[ref])
    );
  }

  applyVisibilities() {
    Object.keys(this.nodeVisibilities).forEach(this.applyVisibility.bind(this));
  }

  applyVisibility(slug) {
    if (this.nodeVisibilities[slug]) {
      this.nodeElements[slug].classList.remove(this.FOLDED_CLASS);
    } else {
      this.nodeElements[slug].classList.add(this.FOLDED_CLASS);
    }
  }

  //=[ Highlighting ]===========================================================

  promiseToMarkNode(slug, terms) {
    return new Promise((resolve, reject) => {
      new Mark(this.nodeElements[slug]).mark(terms, {
        exclude: [this.MARKJS_EXCLUDE_FOLDED],
        done: resolve,
      });
    });
  }

  promiseToMarkTree(results) {
    const promisesToMarkNodes = results.map(
      ({ ref, matchData: { metadata } }) => {
        this.promiseToMarkNode(ref, Object.keys(metadata));
      }
    );
    return Promise.allSettled(promisesToMarkNodes);
  }

  promiseToUnmarkTree() {
    return new Promise((resolve, reject) => {
      new Mark(document).unmark({ done: resolve });
    });
  }

  //=[ (Un)locking ]============================================================

  async setFormLock(locked) {
    this.fieldset.disabled = locked;
    // we need to give slow machines some time to redraw
    await this.sleep(1);
  }

  sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }

  //=[ Events ]=================================================================

  async handleReset(event) {
    await this.clear();
  }

  async handleSubmit(event) {
    event.preventDefault();
    var formData = new FormData(event.target);
    var query = formData.get(this.INPUT_NAME);
    await this.run(query);
  }

  handleClick(event) {
    if (!this.initialized) return;
    const section = event.target.closest(this.NODE_TAG);
    if (!section) return;
    const slug = section.id;
    if (this.nodeVisibilities[slug]) return;
    this.setVisibility(true, slug);
    this.applyVisibility(slug);
  }

  handleToggle() {
    this.form.hidden = !this.form.hidden;
  }

  bindEvents() {
    this.toggle.addEventListener("click", this.handleToggle.bind(this), false);
    document.addEventListener("click", this.handleClick.bind(this), false);
    this.form.addEventListener("submit", this.handleSubmit.bind(this), false);
    this.form.addEventListener("reset", this.handleReset.bind(this), false);
  }
}

document.addEventListener("DOMContentLoaded", function () {
  window.inPageSearch = new InPageSearch();
});
