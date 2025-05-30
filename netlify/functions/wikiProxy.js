// netlify/functions/wikiProxy.js
const fetch = require('node-fetch'); // Використовуємо node-fetch для запитів

exports.handler = async function(event, context) {
  // event.queryStringParameters містить параметри з URL
  // Наприклад, якщо запит був /api/wikiProxy?title=Creeper,
  // то event.queryStringParameters.title буде "Creeper"
  const pageTitle = event.queryStringParameters.title || 'Minecraft'; // Значення за замовчуванням
  const encodedPageTitle = encodeURIComponent(pageTitle);

  const apiUrl = `https://minecraft.wiki/w/api.php?action=query&prop=extracts&exintro&explaintext&titles=${encodedPageTitle}&format=json&origin=*`;

  console.log(`[WikiProxy] Запитую дані для: "${pageTitle}" з URL: ${apiUrl}`);

  try {
    const apiResponse = await fetch(apiUrl, {
      method: 'GET',
      headers: {
        // Minecraft Wiki API зазвичай не потребує спеціальних заголовків для цього типу запиту,
        // але якщо потрібно, їх можна додати тут
        'User-Agent': 'MyPortfolioWikiProxy/1.0 (https://example.com; myemail@example.com)' // Гарна практика - вказувати User-Agent
      }
    });

    if (!apiResponse.ok) {
      const errorText = await apiResponse.text(); // Спробуємо отримати текст помилки
      console.error(`[WikiProxy] Помилка від Wiki API: ${apiResponse.status} ${apiResponse.statusText}. Body: ${errorText}`);
      return {
        statusCode: apiResponse.status,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
          error: `Failed to fetch from Minecraft Wiki: ${apiResponse.status} ${apiResponse.statusText}`,
          details: errorText 
        }),
      };
    }

    const data = await apiResponse.json();
    console.log(`[WikiProxy] Отримано дані від Wiki API для: "${pageTitle}"`);

    return {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json",
        // Netlify автоматично додасть потрібні CORS заголовки для своїх функцій,
        // щоб твій сайт на тому ж домені Netlify міг до них звертатися.
        // "Access-Control-Allow-Origin": "*", // Зазвичай не потрібно тут для Netlify
      },
      body: JSON.stringify(data), // Повертаємо JSON відповідь клієнту
    };
  } catch (error) {
    console.error("[WikiProxy] Внутрішня помилка проксі:", error);
    return {
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ error: "Internal proxy error", details: error.message }),
    };
  }
};