/**
 * Cloudflare Worker Script
 * Proxies requests to the origin host and adds custom headers
 */

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    
    // Get origin host from environment variable
    const originHost = env.ORIGIN_HOST || 'https://vlsc-cloud-app-2001100123.onrender.com';
    
    // Create new request URL pointing to origin
    const originUrl = new URL(url.pathname + url.search, originHost);
    
    // Clone request and add custom headers
    const modifiedRequest = new Request(originUrl, {
      method: request.method,
      headers: new Headers(request.headers),
      body: request.body,
      redirect: 'follow',
    });

    // Add custom headers
    modifiedRequest.headers.set('X-Forwarded-For', request.headers.get('CF-Connecting-IP') || '');
    modifiedRequest.headers.set('X-Forwarded-Proto', 'https');
    modifiedRequest.headers.set('X-Forwarded-Host', url.hostname);

    // Handle CORS
    modifiedRequest.headers.set('Origin', originHost);

    try {
      const response = await fetch(modifiedRequest);
      
      // Add custom response headers
      const newResponse = new Response(response.body, response);
      newResponse.headers.set('X-Powered-By', 'Cloudflare Workers');
      newResponse.headers.set('X-Cache', 'HIT');
      newResponse.headers.set('Access-Control-Allow-Origin', '*');
      
      return newResponse;
    } catch (error) {
      return new Response(
        JSON.stringify({
          error: 'Failed to fetch from origin',
          message: error.message,
        }),
        {
          status: 502,
          headers: { 'Content-Type': 'application/json' },
        }
      );
    }
  },
};
