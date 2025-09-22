'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "1d24954dd4d85ffaccf85277f7ff2d49",
"version.json": "7fa5caf7ef3a54684d9f7588ecdfe0ee",
"index.html": "ff00cd38f996d20639de7cb983609b9f",
"/": "ff00cd38f996d20639de7cb983609b9f",
"main.dart.js": "96da36b833a2270e1eb091df4caec45c",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"favicon.png": "97612d6f100917367023ea180160a4cb",
"icons/Icon-192.png": "a11100db9bf3feaf2a157962b135b5a5",
"icons/Icon-maskable-192.png": "a11100db9bf3feaf2a157962b135b5a5",
"icons/Icon-maskable-512.png": "a11100db9bf3feaf2a157962b135b5a5",
"icons/Icon-512.png": "a11100db9bf3feaf2a157962b135b5a5",
"manifest.json": "3bc15e7a469cb7657dd09d3ddaa0d2b2",
"assets/AssetManifest.json": "a37c6a3458ff9fddbe736d5f7cdba59a",
"assets/NOTICES": "0df38607505790d9abcd2c549b877fd0",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "8092bae163180eea4445224e98a36aa2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/flutter_sound_web/howler/howler.js": "3030c6101d2f8078546711db0d1a24e9",
"assets/packages/flutter_sound_web/src/flutter_sound_recorder.js": "b37654208f2ab2461a0f66424a20335a",
"assets/packages/flutter_sound_web/src/flutter_sound_player.js": "b4ab3574b00feb9165fefd08634da145",
"assets/packages/flutter_sound_web/src/flutter_sound_stream_processor.js": "d466fda2e806ef7abe69ca33ef278c97",
"assets/packages/flutter_sound_web/src/flutter_sound.js": "7e17a336e64c7aaf2ab0fd4fe1e6cf0f",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "79a7d15436455c9bfd7b40a05ab6685a",
"assets/fonts/MaterialIcons-Regular.otf": "bd7fc95f9c8c8b0d75027202fc8a77ac",
"assets/assets/images/yurd_app.png": "922d45a8de5ceb721537661c266da856",
"assets/assets/images/zulamed_app.png": "0e843d1bbe24e1ff8e265a29b56a6d44",
"assets/assets/images/paytolia_app.png": "c8716dc926a2119aed432017b635a49c",
"assets/assets/images/profile_image.png": "9761c4e081a49a1126e5d50b250ce0bb",
"assets/assets/images/tezyu_app.png": "10278f3c01fb8b9b684a0b53a03f0525",
"assets/assets/images/emiland_app.png": "0dedd527f853b885469c454ebc4bd8bc",
"assets/assets/images/next_generation_app.png": "e02c308cb310b7f9f1c3c2968a456e3b",
"assets/assets/images/bonpini_app.png": "95641d164149a8156b6994d3c6c2405f",
"assets/assets/images/greenpay_logo.png": "ca0420e7a994c11d0c442c69baf932eb",
"assets/assets/images/superfon_app.png": "0beeb9988a72dcdd0dc410c01a1989f7",
"assets/assets/images/default_project.png": "7ea2ea3a6f69e2675a9e6974b5eb06a6",
"assets/assets/images/minannonse_app.png": "6c6f5efcc0da246c76ff5bf169e1c7c6",
"assets/assets/images/default_github.png": "aa25731fe7cd3b3c886569125e2ae883",
"assets/assets/images/default.png": "32e4ba43afdb23b6685b4a9b75da782c",
"assets/assets/images/default_skill.png": "ceb1abcc5a6f373853c4d6e517148017",
"assets/assets/sounds/notification_sound.wav": "2b650c9775d903e9c8457aa1104eb98d",
"assets/assets/icons/notification.svg": "3141973ce61973e61dbe44b175883edc",
"assets/assets/data/experience.json": "2d7f6c9f3d8570985a8d1dec54959109",
"assets/assets/data/projects.json": "08563b4931fd98d6cbcf289dbc7c3fd9",
"assets/assets/data/skills.json": "d891758ffdf66d9f4cd7f124bb1b8461",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
