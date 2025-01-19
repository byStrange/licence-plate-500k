<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-8">Checkout</h1>

    <div class="bg-white shadow overflow-hidden sm:rounded-lg">
      <div class="px-4 py-5 sm:p-6">
        <div class="space-y-6">
          <div v-for="item in cart" :key="item.id" class="flex justify-between items-center">
            <div>
              <h3 class="text-lg font-medium">{{ item.number }}</h3>
            </div>
            <div class="text-lg">${{ item.price }}</div>
          </div>

          <div class="border-t border-gray-200 pt-4">
            <div class="flex justify-between">
              <span class="text-lg font-medium">Total:</span>
              <span class="text-lg font-medium">${{ total }}</span>
            </div>
          </div>

          <form @submit.prevent="submitOrder" class="space-y-4">
            <div>
              <label for="name" class="block text-sm font-medium text-gray-700">Name</label>
              <input
                id="name"
                v-model="formData.name"
                type="text"
                required
                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
              >
            </div>

            <div>
              <label for="address" class="block text-sm font-medium text-gray-700">Address</label>
              <textarea
                id="address"
                v-model="formData.address"
                required
                rows="3"
                class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
              ></textarea>
            </div>

            <button
              type="submit"
              class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              Complete Purchase
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()
const cart = useState('cart')
const router = useRouter()

const formData = ref({
  name: '',
  address: ''
})

const total = computed(() => {
  return cart.value.reduce((sum, item) => sum + Number(item.price), 0)
})

const submitOrder = async () => {
  try {
    // Update or create profile
    await client
      .from('profiles')
      .upsert({
        id: user.value.id,
        name: formData.value.name,
        address: formData.value.address
      })

    // Create orders
    for (const plate of cart.value) {
      await client.from('orders').insert({
        plate_id: plate.id,
        user_id: user.value.id
      })

      // Update plate status
      await client
        .from('plates')
        .update({ status: 'sold' })
        .eq('id', plate.id)
    }

    // Clear cart and redirect
    cart.value = []
    await router.push('/myorders')
  } catch (error) {
    console.error('Error submitting order:', error)
  }
}
</script>