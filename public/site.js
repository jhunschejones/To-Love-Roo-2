var app = new Vue({
  el: '#app',
  data: {
    note: {text: ""},
    newNote: "",
    sender: ""
  },
  methods: {
    addNote: async function() {
      fetch("/notes",
        {
          method: "POST",
          mode: "same-origin",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            text: this.newNote.trim()
          })
        }
      ).then(async function(data) {
        data = await data.json();
        app.newNote = "";
        app.note = data;
      })
    },
    getNote: async function() {
      fetch("/notes?query=latest").then(async function(data) {
        data = await data.json();
        app.note = data;
      })
    },
    previousNote: async function() {
      fetch(`/notes/${this.note.id}/previous`).then(async function(data) {
        data = await data.json();
        if (data.error && data.error.message === "There are no more notes.") {
          return false;
        }
        app.note = data;
      })
    },
    randomNote: async function() {
      fetch("/notes?query=random").then(async function(data) {
        data = await data.json();
        app.note = data;
      })
    },
    logOut: function() {
      fetch("/sessions/logout",
        {
          method: "DELETE",
          mode: "same-origin",
          headers: { "Content-Type": "application/json" },
          redirect: "follow" // might not be working
        }
      ).then(function(response) {
        // manually follow redirect
        if (response.redirected) {
          window.location.href = response.url;
        }
      })
    },
  },
  beforeMount(){
    this.getNote();
  },
});
