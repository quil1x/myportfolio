'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/AssetManifest.bin": "5e1c1fe093660a5681ea3f61b03a204a",
"assets/fonts/MaterialIcons-Regular.otf": "df2fae8cfaee5c45ce32884f4532986a",
"assets/AssetManifest.json": "b9063a67ec6160ad88add84a7e1c12ca",
"assets/FontManifest.json": "af72817180f1600c6ad8d83aa72f0a98",
"assets/assets/fonts/PressStart2P-Regular.ttf": "f98cd910425bf727bd54ce767a9b6884",
"assets/assets/audio/portal_travel.mp3": "afc2fb409d61341355d10fcbd5634289",
"assets/assets/audio/minecraft-rare-achievement.mp3": "ddcda8d74298a03ee19f6662a3b264ac",
"assets/assets/audio/creeper.mp3": "ba142aff78f3ef872090897fc0678490",
"assets/assets/audio/creeper-explosion.mp3": "e1a682ca4c1a7cea2d38bd750e4ff4ed",
"assets/assets/minecraft_data/1_20_4_item_tags.json": "8872a5ebc628ed6f5b85207f2de97b86",
"assets/assets/minecraft_data/1_20_4_recipes.json": "15c02dc1c55e880b63ceff005e85761f",
"assets/assets/minecraft_data/1_20_4_block_loot_tables.json": "362214418ac996255fe2636d755ee912",
"assets/assets/minecraft_data/1_20_4_potion_effects.json": "3593d7469d69bacb9d53cccd1879f0d8",
"assets/assets/minecraft_data/1_20_4_biomes.json": "abe42f163041a91e82cc77e04b1486c3",
"assets/assets/minecraft_data/1_20_4_worldgen_flat_level_generator_preset_tags.json": "39a0c3cf80e4d73fa04fd1c655fb4099",
"assets/assets/minecraft_data/1_20_4_sounds.json": "50c5b535c8209ad30f0bd57c57151efd",
"assets/assets/minecraft_data/1_20_4_block_properties.json": "c4588dbcad931f3820d259fff1331d9b",
"assets/assets/minecraft_data/1_20_4_fluid_properties.json": "7a5e342e1c2b7190f76151e9bd541b76",
"assets/assets/minecraft_data/1_20_4_worldgen_structure_tags.json": "fee0f5d1ac117ed105f52fd6e1766658",
"assets/assets/minecraft_data/1_20_4_instrument_tags.json": "9fb4139286cf0f9f62a9c8e04b298cbf",
"assets/assets/minecraft_data/1_20_4_commands.json": "654b1eaef71bc5c226268a6ee04a03d3",
"assets/assets/minecraft_data/1_20_4_fluids.json": "e7cfb2d7cfa67488b1dfdb04351df92c",
"assets/assets/minecraft_data/1_20_4_worldgen_biome_tags.json": "e756614b85c886817e53980fbdd5fd94",
"assets/assets/minecraft_data/1_20_4_poi_type_tags.json": "e162cad698d224d31168b7a2791790ba",
"assets/assets/minecraft_data/1_20_4_attributes.json": "a32798e9acf60e5f8342d55db32f6cf1",
"assets/assets/minecraft_data/1_20_4_custom_statistics.json": "bc2e715765cee270457b513e4921e297",
"assets/assets/minecraft_data/1_20_4_worldgen_world_preset_tags.json": "9f37dd2fa210b38365ccfa2640bac492",
"assets/assets/minecraft_data/1_20_4_block_tags.json": "84a5e85a375b7b5632e4f8c6779d0741",
"assets/assets/minecraft_data/1_20_4_villager_professions.json": "bbb83822ca984566b7f6d653cadec015",
"assets/assets/minecraft_data/1_20_4_entity_type_tags.json": "0b95b4d7bc5f88fb112fed00dbf2ee24",
"assets/assets/minecraft_data/1_20_4_banner_pattern_tags.json": "a0679a88122b988dbe002146e1ff7d43",
"assets/assets/minecraft_data/1_20_4_gameplay_tags.json": "33820625303a00cd25ed919bd1f39683",
"assets/assets/minecraft_data/1_20_4_blocks.json": "677ad69514ad0f72a4e187db885826b8",
"assets/assets/minecraft_data/1_20_4_game_events.json": "de8f512cb467144cae64fa077ff8bbad",
"assets/assets/minecraft_data/1_20_4_cat_variant_tags.json": "6800945c7f554d04a6a3f2a352c3d8d6",
"assets/assets/minecraft_data/1_20_4_fluid_tags.json": "8b1731f9892488cc44b4b9bb8f94d774",
"assets/assets/minecraft_data/1_20_4_entity_data_serializers.json": "7aea070ed805bd1f6872b174530e2094",
"assets/assets/minecraft_data/1_20_4_particles.json": "00da89b4a3758f5158e3fea643d63d5b",
"assets/assets/minecraft_data/1_20_4_enchantments.json": "2461135a0d9668a5cb0798dcbcab6407",
"assets/assets/minecraft_data/1_20_4_dimension_types.json": "59f56c1912deaf175c5833722a843a8d",
"assets/assets/minecraft_data/1_20_4_gameplay_loot_tables.json": "aa588e30eb31d9b087b7d7c3f200a731",
"assets/assets/minecraft_data/1_20_4_chest_loot_tables.json": "d1f38fb4e52ca7a308bba747023f40e7",
"assets/assets/minecraft_data/1_20_4_entity_loot_tables.json": "92b417e40b0d9aacb94a36349f8aefa2",
"assets/assets/minecraft_data/1_20_4_dye_colors.json": "fed7b89fa47b28e0fffa04f5217fe487",
"assets/assets/minecraft_data/1_20_4_entities.json": "004a273675508a103c114544033dafbf",
"assets/assets/minecraft_data/1_20_4_block_entities.json": "13670de7f1b6dee0309c5fe26f49fd9f",
"assets/assets/minecraft_data/1_20_4_villager_types.json": "395048b635f502fc55675a2da1e1706d",
"assets/assets/minecraft_data/1_20_4_sound_sources.json": "e9dfcfe81e067584f0bca0c3513e2615",
"assets/assets/minecraft_data/1_20_4_painting_variant_tags.json": "4e14eca084974f975fbb0126b2b6466e",
"assets/assets/minecraft_data/1_20_4_potions.json": "c7d1f1e6e4fd5ac7108df55a3c28a4d7",
"assets/assets/minecraft_data/1_20_4_items.json": "89fb588f2d534a6940ebd0dd50a25426",
"assets/assets/minecraft_data/1_20_4_packets.json": "3e415b8bf8e01d5bd7b2d8e194f0f88d",
"assets/assets/minecraft_data/1_20_4_map_colors.json": "727bf332fa531e2eae81631fa783ef1b",
"assets/assets/images/minecraft_nether_bg.png": "2c70b6dce70a86b0eb3ce92bc7727473",
"assets/assets/images/bee.png": "056bcfaf57837f12d02dfdc9946258f1",
"assets/assets/images/minecraft_day_bg.png": "e8946a1d1d6abc6ec3b46753acaacfd3",
"assets/assets/images/nether_portal_icon.png": "7a06a10dc54f091e8d8fc4dbf4484a66",
"assets/assets/images/ghast.png": "706383bf0677aeb02520cafc07642b17",
"assets/assets/images/bat.png": "fbe14bfbd28ffe714d2e8cf2fbb9a53f",
"assets/assets/images/minecraft_night_bg.png": "3bf52559d70d62aab2dffda6b0d96426",
"assets/NOTICES": "b66abe7fb45e557cab05dbce976d685e",
"assets/AssetManifest.bin.json": "51fea965efdd864c19cb0d87097bcf94",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"manifest.json": "e2999ae4499b07e4aa045ec7b293aa80",
"index.html": "e9cb1031015e28c12a7cc4542d1c66dd",
"/": "e9cb1031015e28c12a7cc4542d1c66dd",
"version.json": "c4cb027056f49f759fea07eb2dd7df7d",
"flutter_bootstrap.js": "45b33fe78801becd2ddb9605b77e560b",
"main.dart.js": "ee5d377a2dad6bea6e979395608b5bc8",
"favicon.png": "5dcef449791fa27946b3d35ad8803796"};
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
