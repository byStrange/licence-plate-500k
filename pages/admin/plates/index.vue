<template>
  <div>
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-3xl font-bold text-gray-900">Manage License Plates</h1>
      <div class="flex gap-x-2">
        <NuxtLink to="/admin/plates/new"
          class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700">
          Add New Plate
        </NuxtLink>
        <NuxtLink to="/admin/plates/orders"
          class="inline-flex items-center px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700">Manager orders</NuxtLink>
      </div>
    </div>

    <div class="bg-white shadow overflow-hidden sm:rounded-lg">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Number</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Price</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Actions</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-for="plate in plates" :key="plate.id">
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
              {{ plate.number }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              ${{ plate.price }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ plate.status }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              <NuxtLink :to="`/admin/plates/${plate.id}`" class="text-indigo-600 hover:text-indigo-900">
                Edit
              </NuxtLink>
            </td>
          </tr>
        </tbody>
      </table>
    </div>


    <div class="py-12">
      <h1 class="text-3xl font-bold text-gray-900">Sale statistics</h1>
      <Bar id="my-chart-id" :options="chartOptions" :data="chartData" />
    </div>
  </div>
</template>

<script setup>
import { Bar } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)


definePageMeta({
  middleware: ['admin']
})



const client = useSupabaseClient()

const { data: plates } = await useAsyncData('admin-plates', async () => {
  const { data } = await client
    .from('plates')
    .select('*')
  return data
})

const statusCounts = plates.value.reduce((counts, item) => {
  counts[item.status] = (counts[item.status] || 0) + 1;
  return counts;
}, {});

const labels = Object.keys(statusCounts); // ['sold', 'available']
console.log(labels)
const values = Object.values(statusCounts); // [2, 1]

var chartData = {
  labels: labels,
  datasets: [{
    label: 'Orders by Status',
    data: values,
    backgroundColor: [
      'rgba(75, 192, 192, 0.6)', // Color for 'sold'
      'rgba(255, 206, 86, 0.6)', // Color for 'available'
      'rgba(54, 162, 235, 0.6)', // Color for 'pending' (if exists)
    ],
    borderColor: [
      'rgba(75, 192, 192, 1)',
      'rgba(255, 206, 86, 1)',
      'rgba(54, 162, 235, 1)',
    ],
    borderWidth: 1
  }]

}

var chartOptions = {
  responsive: true,
  scales: {
    y: {
      beginAtZero: true,
      ticks: {
        step: 1,
        callback: function (value) {
          // Round to the nearest integer if needed, just to be safe
          return Math.floor(value);  // Ensures integer values
        },
      }
    }
  }
}
</script>
