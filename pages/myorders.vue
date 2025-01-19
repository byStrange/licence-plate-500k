<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-8">My Orders</h1>
    
    <div class="bg-white shadow overflow-hidden sm:rounded-lg">
      <ul role="list" class="divide-y divide-gray-200">
        <li v-for="order in orders" :key="order.id" class="px-4 py-4 sm:px-6">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium text-indigo-600 truncate">
                Plate: {{ order.plates.number }}
              </p>
              <p class="mt-2 flex items-center text-sm text-gray-500">
                <span>Status: {{ order.status }}</span>
              </p>
            </div>
            <div class="ml-2 flex-shrink-0">
              <p class="text-sm text-gray-600">${{ order.plates.price }}</p>
            </div>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const user = useSupabaseUser()

const { data: orders } = await useAsyncData('orders', async () => {
  const { data } = await client
    .from('orders')
    .select('*, plates(*)')
    .eq('user_id', user.value.id)
  return data
})
</script>