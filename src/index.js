import { decode } from 'markov-pack';

function byId(id) {
  return document.getElementById(id);
}

function addOnClick(el, fn) {
  el.addEventListener('click', fn, false);
}

function getBinary(path, cb) {
  const req = new XMLHttpRequest();
  req.open('GET', path, true);
  req.responseType = 'arraybuffer';
  req.onload = () => {
    if (!req.response) {
      return cb('no-response');
    }
    return cb(null, new Uint8Array(req.response));
  };
  return req.send(null);
}

class Page {
  constructor() {
    this.loadBtn = byId('load');
    this.titles = byId('titles');
    this.generateBtn = byId('generate');
    this.controls = byId('controls');
    this.decoder = null;
  }

  setup() {
    addOnClick(this.loadBtn, this.onLoad.bind(this));
    addOnClick(this.generateBtn, this.onGenerate.bind(this));
  }

  onLoad() {
    this.loadBtn.innerText = 'Loading...';
    this.loadBtn.setAttribute('disabled', 'disabled');
    getBinary('papers.makpak', this.onComplete.bind(this));
  }

  onComplete(err, binary) {
    if (err) {
      window.alert(err);
      return;
    }
    this.decoder = new decode.Decoder(binary);
    this.decoder.decode();
    this.loadBtn.remove();
    this.controls.removeAttribute('style');
    this.onGenerate();
  }

  onGenerate() {
    this.titles.innerHTML = '';

    for (let i = 1; i <= 20; i++) {
      const sentence = this.decoder.joinSequence(this.decoder.getSequence());
      const p = document.createElement('p');
      const text = document.createTextNode(sentence);
      p.appendChild(text);
      this.titles.appendChild(p);
    }
  }
}

new Page().setup();
