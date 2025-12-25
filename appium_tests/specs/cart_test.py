describe('Cart Functionality', () => {
    it('should add a product to cart and verify it exists', async () => {
        // 1. Open product
        const firstProduct = await $('~product_item_0');
        await firstProduct.click();

        // 2. Add to cart
        const addToCartBtn = await $('~add_to_cart_button');
        await addToCartBtn.click();

        // 3. Open cart
        const cartIcon = await $('~cart_icon');
        await cartIcon.click();

        // 4. Validate item exists
        const cartItem = await $('~cart_item_name');
        const isExisting = await cartItem.isExisting();
        
        await expect(isExisting).toBe(true);
        
        await browser.saveScreenshot('./docs/results/cart_test_screenshot.png');
    });
});