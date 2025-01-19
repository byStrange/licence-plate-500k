<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-8">Edit License Plate</h1>

    <div class="max-w-2xl mx-auto">
      <form v-if="plate" @submit.prevent="updatePlate" class="space-y-6">
        <div>
          <label for="number" class="block text-sm font-medium text-gray-700">Plate Number</label>
          <input
            id="number"
            v-model="plate.number"
            type="text"
            required
            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          >
        </div>

        <div>
          <label for="price" class="block text-sm font-medium text-gray-700">Price</label>
          <input
            id="price"
            v-model="plate.price"
            type="number"
            step="0.01"
            required
            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          >
        </div>

        <div>
          <label for="status" class="block text-sm font-medium text-gray-700">Status</label>
          <select
            id="status"
            v-model="plate.status"
            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          >
            <option value="available">Available</option>
            <option value="sold">Sold</option>
            <option value="reserved">Reserved</option>
          </select>
        </div>

        <div class="flex justify-end space-x-3">
          <NuxtLink
            to="/admin/plates"
            class="inline-flex justify-center py-2 px-4 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            Cancel
          </NuxtLink>
          <button
            type="submit"
            class="inline-flex justify-center py-2 px-4 border border-transparent shadow-sm text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            Update
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const route = useRoute()
const router = useRouter()

const { data: plate } = await useAsyncData('plate', async () => {
  const { data } = await client
    .from('plates')
    .select('*')
    .eq('id', route.params.id)
    .single()
  return data
})

const updatePlate = async () => {
  try {
    await client
      .from('plates')
      .update(plate.value)
      .eq('id', route.params.id)
    
    await router.push('/admin/plates')
  } catch (error) {
    console.error('Error updating plate:', error)
  }
}
</script>