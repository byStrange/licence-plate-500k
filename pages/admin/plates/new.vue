<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 mb-8">Add New License Plate</h1>

    <div class="max-w-2xl mx-auto">
      <form @submit.prevent="savePlate" class="space-y-6">
        <div>
          <label for="number" class="block text-sm font-medium text-gray-700">Plate Number</label>
          <input
            id="number"
            v-model="plateData.number"
            type="text"
            required
            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          >
        </div>

        <div>
          <label for="price" class="block text-sm font-medium text-gray-700">Price</label>
          <input
            id="price"
            v-model="plateData.price"
            type="number"
            step="0.01"
            required
            class="mt-1 block w-full border border-gray-300 rounded-md shadow-sm py-2 px-3 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500"
          >
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
            Save
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
const client = useSupabaseClient()
const router = useRouter()

const plateData = ref({
  number: '',
  price: 0,
  status: 'available'
})

const savePlate = async () => {
  try {
    await client
      .from('plates')
      .insert(plateData.value)
    
    await router.push('/admin/plates')
  } catch (error) {
    console.error('Error saving plate:', error)
  }
}
</script>
