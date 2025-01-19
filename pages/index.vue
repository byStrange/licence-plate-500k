<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-8">Available License Plates</h1>

    <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
      <div v-for="plate in plates" :key="plate.id" class="bg-white overflow-hidden shadow rounded-lg">
        <div class="px-4 py-5 sm:p-6">
          <div class="text-3xl font-bold text-center mb-4">{{ plate.number }}</div>
          <div class="text-xl text-gray-600 text-center mb-4">${{ plate.price }}</div>
          <button @click="addToCart(plate)"
            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
            Add to Cart
          </button>
        </div>
      </div>
    </div>

    <!-- Shopping Cart -->
    <div v-if="cart.length > 0" class="fixed bottom-0 right-0 m-4">
      <div class="bg-white shadow-lg rounded-lg p-4">
        <h3 class="text-lg font-medium mb-2">Cart ({{ cart.length }})</h3>
        <div class="space-y-2">
          <div v-for="item in cart" :key="item.id" class="flex justify-between">
            <span>{{ item.number }}</span>
            <span>${{ item.price }}</span>
          </div>
        </div>
        <NuxtLink to="/checkout"
          class="mt-4 w-full inline-flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700">
          Checkout
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const cart = useState('cart', () => [])

const { data: plates } = await useAsyncData('plates', async () => {
  const { data } = await client
    .from('plates')
    .select('*')
    .eq('status', 'available')
  return data
})

const addToCart = (plate) => {
  if (cart.value.find((p) => p.number == plate.number)) return;

  cart.value.push(plate)
}
</script>
